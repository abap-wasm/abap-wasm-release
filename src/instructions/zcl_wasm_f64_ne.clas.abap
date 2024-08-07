CLASS zcl_wasm_f64_ne DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body              TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA gi_singleton TYPE REF TO zif_wasm_instruction.
ENDCLASS.



CLASS zcl_wasm_f64_ne IMPLEMENTATION.


  METHOD parse.
    IF gi_singleton IS INITIAL.
      gi_singleton = NEW zcl_wasm_f64_ne( ).
    ENDIF.
    ri_instruction = gi_singleton.
  ENDMETHOD.


  METHOD zif_wasm_instruction~execute.

    DATA(lo_val1) = CAST zcl_wasm_f64( io_memory->mi_stack->pop( ) ).
    DATA(lo_val2) = CAST zcl_wasm_f64( io_memory->mi_stack->pop( ) ).

    DATA(lv_result) = 0.
    IF lo_val1->get_value( ) <> lo_val2->get_value( ).
      lv_result = 1.
    ENDIF.

    io_memory->mi_stack->push( zcl_wasm_i32=>from_signed( lv_result ) ).
  ENDMETHOD.
ENDCLASS.
