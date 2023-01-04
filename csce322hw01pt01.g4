grammar csce322hw01pt01;

// rules
//invalid
invalid_symbol         : ANYTHING {System.out.println("An invalid symbol was found on Line " + $ANYTHING.line);
                                   System.exit(0);}
                         ;

deliveryRoute          : scanned_sections+
                         EOF {System.out.println("End File");}
                         ;
scanned_sections       : scanned_map | scanned_turns
                         ;

//turns
scanned_turns          : TITLE_TURNS {System.out.println("turns Section");}
                         SECTION_BEGINNING {System.out.println("Begin Section");}
                         LIST_BEGINNING {System.out.println("Begin List");}
                         scanned_turn_symbols+
                         LIST_ENDING {System.out.println("End List");}
                         SECTION_ENDING {System.out.println("End Section");}
                         ;

scanned_turn_symbols   : TURN_SEPARATION |
                         (TURN_OPTIONS {System.out.println("Direction: " + $TURN_OPTIONS.text);})
                         ;

//map
scanned_map            : TITLE_MAP {System.out.println("map Section");}
                         SECTION_BEGINNING {System.out.println("Begin Section");}
                         MAP_BEGINNING {System.out.println("Start Map");}
                         scanned_map_rows+
                         scanned_end_row*
                         MAP_ENDING {System.out.println("End Map");}
                         SECTION_ENDING {System.out.println("End Section");}
                         ;

scanned_map_rows       : scanned_map_options+
                         ROW_ENDING {System.out.println("End the Row");}
                         ;

scanned_end_row        : scanned_map_options+
                         ;

scanned_map_options    : BLANK {System.out.println("Location: Blank");} |
                         CROSS {System.out.println("Location: x");} |
                         NUMBER_OPTIONS {System.out.println("Location: " + $NUMBER_OPTIONS.text);} |
                         invalid_symbol
                         ;

// tokens
SECTION_BEGINNING : '\\begin{section}';
SECTION_ENDING    : '\\end{section}';
LIST_BEGINNING    : '\\begin{list}';
LIST_ENDING       : '\\end{list}';
MAP_BEGINNING     : '\\begin{map}';
MAP_ENDING        : '\\end{map}';
ROW_ENDING        : '\\';
TITLE_MAP         : 'map';
TITLE_TURNS       : 'turns';
TURN_OPTIONS      : 'n' | 's' | 'e' | 'w';
TURN_SEPARATION   : '&';
NUMBER_OPTIONS    : '0' | '1' | '2' | '3' | '4' | '5' | '6'| '7' | '8' | '9';
BLANK             : '-';
CROSS             : 'x';
WHITESPACE        : [ \t\n]+ -> skip;
ANYTHING          : .;
