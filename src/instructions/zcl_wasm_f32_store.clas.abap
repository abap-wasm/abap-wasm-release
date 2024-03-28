CLASS zcl_wasm_f32_store DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    METHODS constructor
      IMPORTING
        iv_align  TYPE int8
        iv_offset TYPE int8
      RAISING
        zcx_wasm.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction
      RAISING zcx_wasm.

  PRIVATE SECTION.
    DATA mv_align TYPE int8.
    DATA mv_offset TYPE int8.
ENDCLASS.

CLASS zcl_wasm_f32_store IMPLEMENTATION.

  METHOD constructor.

    mv_align  = iv_align.
    mv_offset = iv_offset.
  ENDMETHOD.

  METHOD parse.
    ri_instruction = NEW zcl_wasm_f32_store(
      iv_align  = io_body->shift_u32( )
      iv_offset = io_body->shift_u32( ) ).
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.

    DATA(li_linear) = io_memory->mi_linear.

    DATA(lv_hex) = CAST zcl_wasm_f32( io_memory->mi_stack->pop( ) )->to_hex( ).

    DATA(lv_i) = io_memory->mi_stack->pop_i32( )->mv_value.

    li_linear->set(
      iv_offset = mv_offset + lv_i
      iv_bytes  = lv_hex ).

  ENDMETHOD.

ENDCLASS.
