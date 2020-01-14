package gmod.panels;
#if client

/**
    Colorful buttons. Used internally by DColorPalette. 
	
	
**/
extern class DColorButton extends DLabel {
    /**
        Returns whether the DColorButton is currently being pressed (the user is holding it down). 
		
		
		**Returns:** 
		
		
    **/
    
     
    public function IsDown():Bool;
    /**
        Used internally by DColorPalette to detect which button is which. 
		
		
		Name | Description
		--- | ---
		`id` | A unique ID to give this button
		
		
		
    **/
    
     
    public function SetID(id:Float):Void;
    /**
        Returns the unique ID set by DColorButton:SetID. 
		
		Used internally by DColorPalette 
		
		 
		**Returns:** The unique ID of the button
		
		
    **/
    
     
    public function GetID():Float;
    /**
        Returns the color of the button 
		
		
		**Returns:** The Color structure of the button
		
		
    **/
    
     
    public function GetColor():AnyTable;
    /**
        Sets the color of the DColorButton. 
		
		
		Name | Description
		--- | ---
		`color` | A Color structure to set the color as
		`noTooltip` | If true, the tooltip will not be reset to display the selected color.
		
		
		
    **/
    
     
    public function SetColor(color:AnyTable, ?noTooltip:Bool):Void;
    
}



#end