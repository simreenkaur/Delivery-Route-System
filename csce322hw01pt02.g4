grammar csce322hw01pt02;

@header{
	import java.util.*;
}

@members{
     double row_ending = 0;
		 double blanks = 0;

     double rows = 0;
     double columns = 0;

     boolean semantic_error = false;
		 boolean semantic_error_four = false;

     int north = 0;
     int south = 0;
     int west = 0;
     int east = 0;

     int vehicles = 0;

     List<String> symbols = new ArrayList<>();

     void semantic_error(int error_number){
          System.out.println("SEMANTIC PROBLEM " + error_number);
     }
}

// rules
invalid_symbol         : anything;

deliveryRoute : parsed_sections {

if( !(vehicles >= 2 && vehicles <=4)){
   semantic_error = true;
	 semantic_error(1);
}

if( ( (rows * columns) * 0.4) < blanks) {
   semantic_error = true;
	 semantic_error(2);
}

if(north == 0 || south == 0 || west == 0 || east == 0){
   semantic_error = true;
	 semantic_error(3);
}

int symbol_count = 0;

int temp_rows = (int)rows;
int temp_columns = (int)columns;

String[][] map = new String[temp_rows][temp_columns];

for(int i = 0; i < temp_rows; i++){
   for(int j = 0; j < temp_columns; j++){
	   map[i][j] = symbols.get(symbol_count);
		 symbol_count++;
	 }
}

int intersections = 0;

for(int i = 0; i < temp_rows; i++){
   for(int j = 0; j < temp_columns; j++){
	   if( !(map[i][j].equals("x")) && !(map[i][j].equals("-")) ) {
		   if(map[i-1][j].equals("x")){
			   intersections++;
			 }
			 if(map[i+1][j].equals("x")){
			   intersections++;
			 }
			 if(map[i][j-1].equals("x")){
			   intersections++;
			 }
			 if(map[i][j+1].equals("x")){
			   intersections++;
			 }
		 }
	 }
}

if(intersections > 1){
  semantic_error = true;
  semantic_error(4);
}

if(semantic_error == false){
    int temp = (int)blanks;
    System.out.println("There are " + temp + " empty spaces on the map .");
}
};

parsed_sections : (parsed_map parsed_turns) |
                  (parsed_turns parsed_map)
									;

parsed_turns : TITLE_TURNS SECTION_BEGINNING LIST_BEGINNING
               parsed_direction TURN_SEPARATION
							 parsed_direction TURN_SEPARATION
							 parsed_direction TURN_SEPARATION
							 (parsed_direction TURN_SEPARATION)+
							 parsed_direction
               LIST_ENDING SECTION_ENDING
							 ;

parsed_direction : (NORTH {north++;} |
                    SOUTH {south++;} |
										WEST {west++;} |
										EAST {east++;})
										;

parsed_map : TITLE_MAP SECTION_BEGINNING MAP_BEGINNING
             parsed_first_row
						 parsed_row parsed_row parsed_row parsed_row parsed_row parsed_row parsed_row parsed_row+
						 parsed_last_row
             MAP_ENDING SECTION_ENDING
						 ;

parsed_first_row : (border_first_row
                    border_first_row
										border_first_row
										border_first_row
										border_first_row
										border_first_row
										border_first_row
										border_first_row
										border_first_row
										border_first_row+
										ROW_ENDING){rows++;}
										;

parsed_last_row : (border_cross
                   border_cross
									 border_cross
									 border_cross
									 border_cross
									 border_cross
									 border_cross
									 border_cross
									 border_cross
									 border_cross+){rows++;}
									 ;

parsed_row : (border_cross
             map_options map_options map_options map_options map_options map_options map_options map_options+
             border_cross ROW_ENDING){rows++;}
						 ;

map_options : blank|
              CROSS{symbols.add($CROSS.text);} |
              vehicles |
              invalid_symbol
							;

border_first_row : (CROSS{ columns++; symbols.add($CROSS.text);} |
                    blank{ columns++;} )
										;

border_cross : CROSS{symbols.add($CROSS.text);} |
               blank
							 ;

blank : BLANK{blanks++; symbols.add($BLANK.text);}
        ;

vehicles : NUMBER_OPTIONS {vehicles++; symbols.add($NUMBER_OPTIONS.text);};

anything : ANYTHING {System.out.println("An invalid symbol was found on Line " + $ANYTHING.line);
                                   System.exit(0);}
                         ;


// tokens
SECTION_BEGINNING : '\\begin{section}';
SECTION_ENDING    : '\\end{section}';
LIST_BEGINNING    : '\\begin{list}';
LIST_ENDING       : '\\end{list}';
MAP_BEGINNING     : '\\begin{map}';
MAP_ENDING        : '\\end{map}';
ROW_ENDING        : '\\\\'{row_ending++;};
TITLE_MAP         : 'map';
TITLE_TURNS       : 'turns';
NORTH             : 'n';
SOUTH             : 's';
WEST              : 'w';
EAST              : 'e';
TURN_SEPARATION   : '&';
NUMBER_OPTIONS    : '0' | '1' | '2' | '3' | '4' | '5' | '6'| '7' | '8' | '9';
BLANK             : '-';
CROSS             : 'x';
WHITESPACE        : [ \t\n]+ -> skip;
ANYTHING          : .;
