CLASS zcl_wasm_local_set DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES zif_wasm_instruction.

    CLASS-METHODS class_constructor.

    METHODS constructor
      IMPORTING
        !iv_localidx TYPE i.

    CLASS-METHODS parse
      IMPORTING !io_body              TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction
      RAISING zcx_wasm.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_localidx TYPE i.
    CLASS-DATA gt_singletons TYPE STANDARD TABLE OF REF TO zcl_wasm_local_set WITH DEFAULT KEY.
ENDCLASS.

CLASS zcl_wasm_local_set IMPLEMENTATION.

  METHOD constructor.
    mv_localidx = iv_localidx.
  ENDMETHOD.

  METHOD class_constructor.
    DO 100 TIMES.
      DATA(lo_get) = NEW zcl_wasm_local_set( sy-index ).
      INSERT lo_get INTO TABLE gt_singletons.
    ENDDO.
  ENDMETHOD.

  METHOD parse.
    DATA lv_idx TYPE i.
    lv_idx = io_body->shift_u32( ) + 1.
    READ TABLE gt_singletons INDEX lv_idx INTO ri_instruction.
    IF sy-subrc <> 0.
      ri_instruction = NEW zcl_wasm_local_set( lv_idx + 1 ).
    ENDIF.
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.

* https://webassembly.github.io/spec/core/exec/instructions.html#xref-syntax-instructions-syntax-instr-variable-mathsf-local-set-x

    DATA(li_value) = io_memory->mi_stack->pop( ).

    MODIFY io_memory->mt_locals INDEX mv_localidx FROM li_value.

  ENDMETHOD.

ENDCLASS.
