CLASS zcl_wasm_f32_copysign DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body              TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
  PRIVATE SECTION.
    CLASS-DATA gi_singleton TYPE REF TO zif_wasm_instruction.
ENDCLASS.

CLASS zcl_wasm_f32_copysign IMPLEMENTATION.

  METHOD parse.
    IF gi_singleton IS INITIAL.
      gi_singleton = NEW zcl_wasm_f32_copysign( ).
    ENDIF.
    ri_instruction = gi_singleton.
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.

* https://webassembly.github.io/spec/core/exec/numerics.html#xref-exec-numerics-op-fcopysign-mathrm-fcopysign-n-z-1-z-2

* If z1 and z2 have the same sign, then return z1. Else return z1 with negated sign

    DATA(li_val1) = io_memory->mi_stack->pop( ).
    DATA(li_z1) = CAST zcl_wasm_f32( li_val1 ).

    DATA(li_val2) = io_memory->mi_stack->pop( ).
    DATA(li_z2) = CAST zcl_wasm_f32( li_val2 ).

    IF li_z1->get_sign( ) = li_z2->get_sign( ).
      io_memory->mi_stack->push( li_z1 ).
    ELSE.
      io_memory->mi_stack->push( zcl_wasm_f32=>from_float( - li_z1->get_value( ) ) ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
