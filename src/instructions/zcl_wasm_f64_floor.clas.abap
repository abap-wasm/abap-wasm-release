CLASS zcl_wasm_f64_floor DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body              TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA gi_singleton TYPE REF TO zif_wasm_instruction.
ENDCLASS.



CLASS zcl_wasm_f64_floor IMPLEMENTATION.


  METHOD parse.
    IF gi_singleton IS INITIAL.
      gi_singleton = NEW zcl_wasm_f64_floor( ).
    ENDIF.
    ri_instruction = gi_singleton.
  ENDMETHOD.


  METHOD zif_wasm_instruction~execute.

    DATA(lo_val) = CAST zcl_wasm_f64( io_memory->mi_stack->pop( ) ).

    io_memory->mi_stack->push( zcl_wasm_f64=>from_float( floor( lo_val->get_value( ) ) ) ).
  ENDMETHOD.
ENDCLASS.
