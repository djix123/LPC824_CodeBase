/*
 * generic gcc linker script for LPC810
 * Kamal Mostafa <kamal@whence.com>.
 *
 * License: Public Domain
 */

MEMORY
{
    /* NXP LPC824 */
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 0x00008000 /* 32 Kbytes */
    RAM (rwx) :  ORIGIN = 0x10000000, LENGTH = 0x00001000 /* 4 Kbyte */
}

SECTIONS
{
    .text :
    {
        _text = .;
        KEEP(*(.isr_vector))
        KEEP(*(.after_vectors))
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
        _etext = .;
    } > FLASH

    .data : AT (_etext)
    {
        _data = .;
        *(vtable)
        *(.data*)
        _edata = .;
    } > RAM

    .bss :
    {
        _bss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > RAM
}

PROVIDE(_vStackTop = ORIGIN(RAM) + LENGTH(RAM));

PROVIDE (__valid_user_code_checksum = 0 -
    (_vStackTop
    + (ResetISR + 1)
    + (NMI_Handler + 1)
    + (HardFault_Handler + 1)
    ));

ENTRY(ResetISR);