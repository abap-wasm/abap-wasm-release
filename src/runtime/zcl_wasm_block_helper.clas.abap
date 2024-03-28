CLASS zcl_wasm_block_helper DEFINITION PUBLIC.
  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        iv_block_type TYPE xstring
        io_module     TYPE REF TO zcl_wasm_module
      RAISING
        zcx_wasm.

    METHODS start
      IMPORTING io_memory TYPE REF TO zcl_wasm_memory
      RAISING zcx_wasm.

    METHODS end
      IMPORTING io_memory TYPE REF TO zcl_wasm_memory
      RAISING zcx_wasm.

  PRIVATE SECTION.
    DATA ms_type TYPE zcl_wasm_module=>ty_type.
    DATA mi_old  TYPE REF TO zif_wasm_memory_stack.
ENDCLASS.

CLASS zcl_wasm_block_helper IMPLEMENTATION.

  METHOD constructor.

    DATA lv_int8 TYPE int8.

    CASE iv_block_type.
      WHEN zif_wasm_types=>c_empty_block_type.
        RETURN.
      WHEN zif_wasm_types=>c_value_type-i32
          OR zif_wasm_types=>c_value_type-i64
          OR zif_wasm_types=>c_value_type-f32
          OR zif_wasm_types=>c_value_type-f64
          OR zif_wasm_types=>c_reftype-funcref
          OR zif_wasm_types=>c_reftype-externref
          OR zif_wasm_types=>c_vector_type.
        ms_type-result_types = iv_block_type.
      WHEN OTHERS.
        lv_int8 = iv_block_type.
        ms_type = io_module->get_type_by_index( lv_int8 ).
    ENDCASE.

  ENDMETHOD.

  METHOD start.
    IF ms_type IS INITIAL.
* empty block type
      RETURN.
    ENDIF.

    mi_old = io_memory->mi_stack.
    DATA(li_new) = CAST zif_wasm_memory_stack( NEW zcl_wasm_memory_stack( ) ).
    io_memory->mi_stack = li_new.

    DO xstrlen( ms_type-parameter_types ) TIMES.
      DATA(lv_offset) = xstrlen( ms_type-parameter_types ) - sy-index.
      DATA(li_val) = mi_old->pop( ).

      li_new->push( li_val ).
    ENDDO.
  ENDMETHOD.

  METHOD end.
    DATA lt_results TYPE STANDARD TABLE OF REF TO zif_wasm_value WITH EMPTY KEY.

    IF ms_type IS INITIAL.
* empty block type
      RETURN.
    ENDIF.

    DO xstrlen( ms_type-result_types ) TIMES.
      DATA(lv_offset) = xstrlen( ms_type-result_types ) - sy-index.
      DATA(li_val) = io_memory->mi_stack->pop( ).

      INSERT li_val INTO lt_results INDEX 1.
    ENDDO.

    LOOP AT lt_results INTO li_val.
      mi_old->push( li_val ).
    ENDLOOP.

    io_memory->mi_stack = mi_old.
  ENDMETHOD.

ENDCLASS.
