package gmod.panels;
#if client

/**
    The little "+" button used by  and .  Inherits the following functions from DButton and its parents up to 3 levels deep: 
	
	
**/
extern class DExpandButton extends DButton {
    /**
        Returns whether this DExpandButton is expanded or not. 
		
		
		**Returns:** True if expanded, false otherwise
		
		
    **/
    
     
    public function GetExpanded():Bool;
    /**
        Sets whether this DExpandButton should be expanded or not. Only changes appearance. 
		
		
		Name | Description
		--- | ---
		`expanded` | True to expand ( visually will show a "-" )
		
		
		
    **/
    
     
    public function SetExpanded(expanded:Bool):Void;
    
}



#end