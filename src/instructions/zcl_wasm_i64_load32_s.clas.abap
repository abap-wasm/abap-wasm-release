CLASS zcl_wasm_i64_load32_s DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    METHODS constructor
      IMPORTING
        iv_align  TYPE int8
        iv_offset TYPE int8
      RAISING
        zcx_wasm.

    CLASS-METHODS parse
      IMPORTING !io_body              TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction
      RAISING zcx_wasm.

  PRIVATE SECTION.
    DATA mv_align TYPE int8.
    DATA mv_offset TYPE int8.
ENDCLASS.

CLASS zcl_wasm_i64_load32_s IMPLEMENTATION.

  METHOD constructor.

    mv_align  = iv_align.
    mv_offset = iv_offset.
  ENDMETHOD.

  METHOD parse.
    ri_instruction = NEW zcl_wasm_i64_load32_s(
      iv_align  = io_body->shift_u32( )
      iv_offset = io_body->shift_u32( ) ).
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
    CONSTANTS lc_length TYPE int8 VALUE 4.
    DATA lv_hex TYPE x LENGTH lc_length.
    DATA lv_int TYPE i.
    DATA lv_int8 TYPE int8.

    DATA(lv_i) = io_memory->mi_stack->pop_i32( )->mv_value.

    lv_hex = io_memory->mi_linear->get(
      iv_length = lc_length
      iv_align  = mv_align
      iv_offset = mv_offset + lv_i ).

    lv_int = lv_hex.
    lv_int8 = lv_int.
    io_memory->mi_stack->push( zcl_wasm_i64=>from_signed( lv_int8 ) ).
  ENDMETHOD.

ENDCLASS.
