CLASS zcl_wasm_i64_extend_i32_s DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
  PRIVATE SECTION.
    CLASS-DATA gi_singleton TYPE REF TO zif_wasm_instruction.
ENDCLASS.

CLASS zcl_wasm_i64_extend_i32_s IMPLEMENTATION.

  METHOD parse.
    IF gi_singleton IS INITIAL.
      gi_singleton = NEW zcl_wasm_i64_extend_i32_s( ).
    ENDIF.
    ri_instruction = gi_singleton.
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
    DATA lv_val TYPE int8.
    lv_val = io_memory->mi_stack->pop_i32( )->mv_value.
    io_memory->mi_stack->push( zcl_wasm_i64=>from_signed( lv_val ) ).
  ENDMETHOD.

ENDCLASS.
