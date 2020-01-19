package gmod.panels;
#if client

/**
    Panel used to display models, used by .  
**/
extern class ModelImage {
    /**
        Causes a SpawnIcon to rebuild its model image. 
		
		
		
    **/
    
     
    public function RebuildSpawnIcon():Void;
    /**
        Sets the model to be displayed by .        
		Name | Description
		--- | ---
		`ModelPath` | The path of the model to set
		`skin` | The skin to set
		`bodygroups` | The body groups to set. Each single-digit number in the string represents a separate bodygroup, up to 9 in total.
		
		
		
    **/
    
     
    public function SetModel(ModelPath:String, ?skin:Float, ?bodygroups:String):Void;
    /**
        Re-renders a spawn icon with customized cam data. 
		
		PositionSpawnIcon can be used to easily calculate the necessary camera parameters. 
		
		 
		Name | Description
		--- | ---
		`data` | A four-membered table containing the information needed to re-render: Vector cam_pos - The relative camera position the model is viewed from. Angle cam_ang - The camera angle the model is viewed from. number cam_fov - The camera's field of view (FOV). Entity ent - The entity object of the model. See the example below for how to retrieve these values.
		
		
		___
		### Lua Examples
		#### Example 1
		The RenderIcon method used by IconEditor. SpawnIcon is a SpawnIcon and ModelPanel is a DAdjustableModelPanel.
		
		```lua 
		function PANEL:RenderIcon()
		    
		    local ent = self.ModelPanel:GetEntity()
		    
		    local tab = {}
		    tab.ent        = ent
		    tab.cam_pos = self.ModelPanel:GetCamPos()
		    tab.cam_ang = self.ModelPanel:GetLookAng()
		    tab.cam_fov = self.ModelPanel:GetFOV()
		
		    self.SpawnIcon:RebuildSpawnIconEx( tab )
		end
		```
		
		
    **/
    
     
    public function RebuildSpawnIconEx(data:AnyTable):Void;
    /**
        Sets the .png image to be displayed on a  or the panel it is based on . Only .png images can be used with this function. 
		
		
		Name | Description
		--- | ---
		`icon` | A path to the .png material, for example one of the Silkicons shipped with the game.
		
		
		
    **/
    
     
    public function SetSpawnIcon(icon:String):Void;
    
}



#end