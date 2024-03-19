CLASS zcl_wasm_f32_trunc DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
  PRIVATE SECTION.
    CLASS-DATA gi_singleton TYPE REF TO zif_wasm_instruction.
ENDCLASS.

CLASS zcl_wasm_f32_trunc IMPLEMENTATION.

  METHOD parse.
    IF gi_singleton IS INITIAL.
      gi_singleton = NEW zcl_wasm_f32_trunc( ).
    ENDIF.
    ri_instruction = gi_singleton.
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
    zcl_wasm_f32=>trunc_value( io_memory ).
  ENDMETHOD.

ENDCLASS.
