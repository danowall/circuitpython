/*
    GNU linker script for SAMD21
*/

/* Specify the memory areas */
MEMORY
{
    /* Leave 8KiB for the bootloader, and 64k for the flash file system. */
    FLASH (rx) : ORIGIN = 0x00000000+0x2000, LENGTH = 0x00040000 - 0x2000 - 0x010000
    RAM (xrw)       : ORIGIN = 0x20000000, LENGTH = 0x008000 /* 32 KiB */
}

/* top end of the stack */
_estack = ORIGIN(RAM) + LENGTH(RAM);

/* define output sections */
SECTIONS
{
    /* The program code and other data goes into FLASH */
    .text :
    {
        . = ALIGN(4);
        _sfixed = .;
        KEEP(*(.vectors)) /* isr vector table */
        *(.text)           /* .text sections (code) */
        *(.text*)          /* .text* sections (code) */
        *(.rodata)         /* .rodata sections (constants, strings, etc.) */
        *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */

        . = ALIGN(4);
        _etext = .;        /* define a global symbol at end of code */
    } >FLASH

    .ARM.exidx :
    {
        *(.ARM.exidx*)
        *(.gnu.linkonce.armexidx.*)
        _sidata = .;  /* This is used by the startup in order to initialize the .data section */
    } > FLASH

    /* This is the initialized data section
    The program executes knowing that the data is in the RAM
    but the loader puts the initial values in the FLASH (inidata).
    It is one task of the startup to copy the initial values from FLASH to RAM. */
    .data : AT ( _sidata )
    {
        . = ALIGN(4);
        _srelocate = .;        /* create a global symbol at data start; used by startup code in order to initialize the .data section in RAM */
        *(.ramfunc)
        *(.ramfunc*)
        *(.data)           /* .data sections */
        *(.data*)          /* .data* sections */

        . = ALIGN(4);
        _erelocate = .;        /* define a global symbol at data end; used by startup code in order to initialize the .data section in RAM */
    } >RAM

    /* Uninitialized data section */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        _szero = .;         /* define a global symbol at bss start; used by startup code */
        *(.bss)
        *(.bss*)
        *(COMMON)

        . = ALIGN(4);
        _ezero = .;         /* define a global symbol at bss end; used by startup code */
        _ebss = .;
    } >RAM

    /* this just checks there is enough RAM for a minimal stack */
    .stack :
    {
        . = ALIGN(4);
        . = . + 0x800; /* Reserve a minimum of 2K for the stack. */
        . = ALIGN(4);
    } >RAM

    .ARM.attributes 0 : { *(.ARM.attributes) }
}
