CLASS zcl_wasm_i32_lt_u DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
  PRIVATE SECTION.
    CLASS-DATA gi_singleton TYPE REF TO zif_wasm_instruction.
ENDCLASS.

CLASS zcl_wasm_i32_lt_u IMPLEMENTATION.

  METHOD parse.
    IF gi_singleton IS INITIAL.
      gi_singleton = NEW zcl_wasm_i32_lt_u( ).
    ENDIF.
    ri_instruction = gi_singleton.
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.

    DATA(lo_val1) = CAST zcl_wasm_i32( io_memory->mi_stack->pop( ) ).
    DATA(lo_val2) = CAST zcl_wasm_i32( io_memory->mi_stack->pop( ) ).

    DATA(lv_result) = 0.
    IF lo_val1->get_unsigned( ) > lo_val2->get_unsigned( ).
      lv_result = 1.
    ENDIF.

    io_memory->mi_stack->push( zcl_wasm_i32=>from_signed( lv_result ) ).
  ENDMETHOD.

ENDCLASS.
