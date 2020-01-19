package gmod.panels;
#if client

/**
    A panel that fades its contents in and out once, like a notification.
**/
extern class DNotify extends Panel {
    /**
        Sets the spacing between child elements of the notification panel.
		
		Name | Description
		--- | ---
		`spacing` | 
    **/
    
     
    public function SetSpacing(spacing:Float):Void;
    /**
        ***INTERNAL** 
    **/
    @:deprecated("INTERNAL")
     
    public function Shuffle():Void;
    /**
        Adds a panel to the notification
		
		Name | Description
		--- | ---
		`pnl` | The panel to add
		`lifeLength` | If set, overrides DNotify: SetLife.
    **/
    
     
    public function AddItem(pnl:Panel, ?lifeLength:Float):Void;
    /**
        Returns all the items added with DNotify:AddItem.
		
		`**Returns:** A table of Panels.
    **/
    
     
    public function GetItems():AnyTable;
    /**
        Returns the current alignment of this notification panel. Set by DNotify:SetAlignment.
		
		`**Returns:** The numpad alignment
    **/
    
     
    public function GetAlignment():Float;
    /**
        Sets the alignment of the child panels in the notification
		
		Name | Description
		--- | ---
		`alignment` | It's the Numpad alignment, 6 is right, 9 is top left, etc.
    **/
    
     
    public function SetAlignment(alignment:Float):Void;
    /**
        Returns the spacing between items set by DNotify:SetSpacing.
		
		`**Returns:** 
    **/
    
     
    public function GetSpacing():Float;
    /**
        Sets the display time in seconds for the DNotify.
		
		Name | Description
		--- | ---
		`time` | The time in seconds.
    **/
    
     
    public function SetLife(time:Float):Void;
    /**
        Returns the display time in seconds of the DNotify. This is set with DNotify:SetLife.
		
		`**Returns:** The display time in seconds.
    **/
    
     
    public function GetLife():Float;
    
}



#end