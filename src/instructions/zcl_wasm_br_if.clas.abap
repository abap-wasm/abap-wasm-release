CLASS zcl_wasm_br_if DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        iv_labelidx TYPE int8.

    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction
      RAISING zcx_wasm.

  PRIVATE SECTION.
    DATA mv_labelidx TYPE int8.
ENDCLASS.

CLASS zcl_wasm_br_if IMPLEMENTATION.

  METHOD constructor.
    mv_labelidx = iv_labelidx.
  ENDMETHOD.

  METHOD parse.
    ri_instruction = NEW zcl_wasm_br_if( io_body->shift_u32( ) ).
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
* Unlike with other index spaces, indexing of labels is relative by nesting depth, that is, label
* refers to the innermost structured control instruction enclosing the referring branch instruction,
* while increasing indices refer to those farther out.

* https://webassembly.github.io/spec/core/exec/instructions.html#xref-syntax-instructions-syntax-instr-control-mathsf-br-if-l

    DATA(li_value) = io_memory->mi_stack->pop( ).

    IF CAST zcl_wasm_i32( li_value )->get_signed( ) = 0.
      RETURN.
    ENDIF.

* yea, using exceptions for branching is probably slow, but will work for now
    RAISE EXCEPTION TYPE zcx_wasm_branch EXPORTING depth = mv_labelidx.
  ENDMETHOD.

ENDCLASS.