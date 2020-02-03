package gmod.macros;
#if macro
//import gmod.libs.ConcommandLib;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;
import haxe.macro.Compiler;

import haxe.macro.Expr.Position;
import haxe.macro.Context;
import haxe.macro.Expr.TypeDefinition;
using haxe.macro.TypeTools;
using StringTools;
#end
class InitMacro {
    #if macro
    public static var baseEntFolder:String;
    #end
    public static var exportName:String;
    #if macro
    // @:persistent static var firstBuild = true;
    
    //TODO Add all gmod.hooks.Panel to gmod.panel.Panel
    static function testFunc(x:String):TypeDefinition {
        if (x.startsWith("PanelHelper_")) {
            var ident = x.substring(12);
            
            var _class = macro class $x{
                
                function new() {

                }
                
            }
            var lookup:haxe.macro.Type;
            try {
                lookup = Context.getType('gmod.panels.$ident');
            } catch (e:String) {
                Context.warning('Could not find panel...$ident',Context.currentPos());
                return null;
            }
            var fields = gmod.macros.PanelMacro.getSuperFields(lookup.getClass());
            for (field in fields) {
                _class.fields.push(gmod.macros.PanelMacro.classFuncToField(field));
            }
            return _class;
        }
        return null;
    }

    static public function init() {
        Compiler.exclude("lua.lib",true);
        Compiler.exclude("Sys",true);
        Context.onTypeNotFound(testFunc);
        Compiler.includeFile("include.lua",IncludePosition.Top);
        #if (!display)
        // if (firstBuild) {
        //     trace("skipping first build");
        //     firstBuild = false;
        //     return;
        // }
        
        var addonName:String;

        
        
        
        if (!Context.defined("lua") || Context.defined("display_details") ) {
            return;
        }
        
        trace(Compiler.getOutput());
        
        if (Context.defined("addonName")) {
            
            addonName = Context.definedValue("addonName").toLowerCase();
            FileSystem.createDirectory('generated/${addonName}');
        } else {
            Context.warning("InitMacro : No \"-D addonName=your_addon_name_here\" defined in .hxml file. Will not generate folder structure",Context.currentPos());
            return;
            // Context.fatalError("InitMacro : No \"-d addonName=your_addon_name_here\" defined in .hxml file. Cannot continue",Context.currentPos());
        }
        
       
        //trace(Context.getDefines());
        var serverName = "haxe_init";
        var clientName = "haxe_cl_init";
        if (Context.defined("gamemode")) {
            var gamemodeName = Context.definedValue("gamemode").toLowerCase();
            exportName = '${gamemodeName.toLowerCase()}_HAXE_EXPORT';
            baseEntFolder = 'generated/$addonName/gamemodes/$gamemodeName/entities';
            FileSystem.createDirectory('$baseEntFolder/entities');
            FileSystem.createDirectory('$baseEntFolder/effects');
            FileSystem.createDirectory('$baseEntFolder/weapons');
            FileSystem.createDirectory('generated/$addonName/gamemodes/$gamemodeName/gamemode');
            if (Context.defined("client")) {
                if (Context.defined("generateLuaInit")) {
                    File.saveContent('generated/$addonName/gamemodes/$gamemodeName/gamemode/cl_init.lua',
                    '$exportName = include("$clientName.lua")');
                }
                trace("generated client.lua");
                Compiler.setOutput('generated/$addonName/gamemodes/$gamemodeName/gamemode/$clientName.lua');
            } else if (Context.defined("server")) {
                if (Context.defined("generateLuaInit")) {
                    File.saveContent('generated/$addonName/gamemodes/$gamemodeName/gamemode/init.lua',
                    'AddCSLuaFile("$clientName.lua")\n$exportName = include("$serverName.lua")');
                }
                trace("generated server.lua");
                Compiler.setOutput('generated/$addonName/gamemodes/$gamemodeName/gamemode/$serverName.lua');
            }
            
        } else {
            exportName = '${addonName}_HAXE_EXPORT';
            
            baseEntFolder = 'generated/$addonName/lua';
            FileSystem.createDirectory('generated/$addonName/lua/autorun/');
            FileSystem.createDirectory('generated/$addonName/lua/$addonName');
            if (Context.defined("generateLuaInit")) {
                var haxe_init:String = 'if SERVER then AddCSLuaFile("$addonName/cl_init.lua") $exportName = include("$addonName/init.lua") end\nif CLIENT then $exportName = include("$addonName/cl_init.lua") end';
                File.saveContent('generated/$addonName/lua/autorun/haxe_init_$addonName.lua',haxe_init);
            }
            if (Context.defined("client")) {
                trace("generated non gamemode client.lua");
                //Compiler.includeFile('');
                Compiler.setOutput('generated/$addonName/lua/$addonName/$clientName.lua');
            } else if (Context.defined("server")) {
                trace("generated non gamemode server.lua");
                Compiler.setOutput('generated/$addonName/lua/$addonName/$serverName.lua');
            }
            
            
        }
        if (Context.defined("gmodAddonFolder")) {
            Context.onAfterGenerate(updateAddonFolder);
        }
        #end
    }
    static function updateAddonFolder() {
        #if !display
        var gmodAddonFolder = Context.definedValue("gmodAddonFolder");
        
        var exists = FileSystem.exists(gmodAddonFolder);
        var abs = Path.isAbsolute(gmodAddonFolder);
        
        var isdir = FileSystem.isDirectory(gmodAddonFolder);
        switch ([exists,abs,isdir]) {
            case [true,true,true]:
                recurseCopy("generated",gmodAddonFolder);
            case [false,_,_]:
                Context.warning("gmodAddonFolder defined but does not exist",Context.currentPos());
            case [_,false,_]:
                Context.warning("gmodAddonFolder defined but is in invalid format",Context.currentPos());
            case [_,_,false]:
                Context.warning("gmodAddonFolder defined but is not a directory",Context.currentPos());
        }
            
        
        
        // for (FileSystem.readDirectory("generated")) {

        // }
        #end

    }

    static function recurseCopy(curFolder:String,output:String) {
        #if !display
        for (name in FileSystem.readDirectory(curFolder)) {
            var curFile = Path.join([curFolder,name]);
            var otherFile = Path.join([output,name]);
            if (FileSystem.isDirectory(Path.join([curFolder,name]))) {
                //trace('directory: $curFile $otherFile');
                FileSystem.createDirectory(otherFile);
                recurseCopy(Path.join([curFolder,name]),Path.join([output,name]));
            } else {
                //trace('file: $curFile $otherFile');
                File.copy(curFile,otherFile);
                //File.copy(Path.join([curFolder,name]),)
            }
        }
        #end
    }

#end
}