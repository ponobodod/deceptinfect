package gmod.panels;
#if client

/**
    DIconLayout is what replaced DPanelList in Garry's Mod 13. DPanelList still exists in GMod but is deprecated and does not support the new GWEN skin. 
	
	DIconLayout is used to make a list of panels. Unlike DPanelList, DIconLayout does not automatically add a scroll bar - the example below shows you how you can do this. 
	
	 
**/
extern class DIconLayout extends DDragBase {
    /**
        Returns whether the icon layout will stretch its width to fit all the children. 
		
		See also DIconLayout:GetStretchHeight 
		
		 
		**Returns:** 
		
		
    **/
    
     
    public function GetStretchWidth():Bool;
    /**
        Sets the horizontal (x) spacing between children within the DIconLayout. You must call DIconLayout:Layout in order for the changes to take effect. 
		
		
		Name | Description
		--- | ---
		`xSpacing` | The width of the gap between child objects.
		
		
		
    **/
    
     
    public function SetSpaceX(xSpacing:Float):Void;
    /**
        Returns the size of the border. 
		
		
		**Returns:** 
		
		
    **/
    
     
    public function GetBorder():Float;
    /**
        Returns the direction that it will be layed out, using the DOCK enumerations. 
		
		
		**Returns:** Layout direction.
		
		
    **/
    
     
    public function GetLayoutDir():Float;
    /**
        Called when the panel is modified. 
		
		
		
    **/
    
    @:hook 
    public function OnModified():Void;
    /**
        ***INTERNAL:**  
		
		Used internally to layout the child elements if the DIconLayout:SetLayoutDir is set to TOP (See DOCK_ Enums). 
		
		
		
    **/
    @:deprecated
     
    public function LayoutIcons_TOP():Void;
    /**
        Sets the internal border (padding) within the DIconLayout. This will not change its size, only the positioning of children. You must call DIconLayout:Layout in order for the changes to take effect. 
		
		
		Name | Description
		--- | ---
		`width` | The border (padding) inside the DIconLayout.
		
		
		
    **/
    
     
    public function SetBorder(width:Float):Void;
    /**
        If set to true, the icon layout will stretch its height to fit all the children. 
		
		See also DIconLayout:SetStretchWidth 
		
		 
		Name | Description
		--- | ---
		`do_stretch` | 
		
		
		
    **/
    
     
    public function SetStretchHeight(do_stretch:Bool):Void;
    /**
        If set to true, the icon layout will stretch its width to fit all the children. 
		
		See also DIconLayout:SetStretchHeight 
		
		 
		Name | Description
		--- | ---
		`stretchW` | 
		
		
		
    **/
    
     
    public function SetStretchWidth(stretchW:Bool):Void;
    /**
        Returns the distance between two 'icons' on the X axis. 
		
		
		**Returns:** Distance between two 'icons' on the X axis.
		
		
    **/
    
     
    public function GetSpaceX():Float;
    /**
        Sets the direction that it will be layed out, using the DOCK_ Enums. 
		
		Currently only TOP and LEFT are supported. 
		
		 
		Name | Description
		--- | ---
		`direction` | DOCK_ Enums
		
		
		
    **/
    
     
    public function SetLayoutDir(direction:Float):Void;
    /**
        Returns whether the icon layout will stretch its height to fit all the children. 
		
		See also DIconLayout:GetStretchWidth 
		
		 
		**Returns:** 
		
		
    **/
    
     
    public function GetStretchHeight():Bool;
    /**
        Copies the contents (Child elements) of another DIconLayout to itself. 
		
		
		Name | Description
		--- | ---
		`from` | DIconLayout to copy from.
		
		
		
    **/
    
     
    public function CopyContents(from:Panel):Void;
    /**
        Sets the vertical (y) spacing between children within the DIconLayout. You must call DIconLayout:Layout in order for the changes to take effect. 
		
		
		Name | Description
		--- | ---
		`ySpacing` | The vertical gap between rows in the DIconLayout.
		
		
		
    **/
    
     
    public function SetSpaceY(ySpacing:Float):Void;
    /**
        Creates a replica of the DIconLayout it is called on. 
		
		
		**Returns:** The replica.
		
		
    **/
    
     
    public function Copy():Panel;
    /**
        Returns distance between two "Icons" on the Y axis. 
		
		
		**Returns:** distance between two "Icons" on the Y axis.
		
		
    **/
    
     
    public function GetSpaceY():Float;
    /**
        ***INTERNAL:**  
		
		Used internally to layout the child elements if the DIconLayout:SetLayoutDir is set to LEFT (See DOCK_ Enums). 
		
		
		
    **/
    @:deprecated
     
    public function LayoutIcons_LEFT():Void;
    /**
        Resets layout vars before calling Panel:InvalidateLayout. This is called when children are added or removed, and must be called when the spacing, border or layout direction is changed. 
		
		
		
    **/
    
     
    public function Layout():Void;
    
}



#end