/*
    GNU linker script for NRF52 w/ s132 2.0.1 SoftDevice

    MEMORY MAP
    ------------------------------------------------------------------------
    START ADDR  END ADDR   SIZE    DESCRIPTION
    ----------  ---------- ------- -----------------------------------------
    0x00074000..0x00080000 ( 48KB) Serial + OTA Bootloader
    0x0006D000..0x00073FFF ( 28KB) Private Config Data (Bonding, Keys, etc.)
    0x00055000..0x0006CFFF ( 96KB) User Filesystem
    0x0001C000..0x00054FFF (228KB) Application Code
    0x00001000..0x0001BFFF (108KB) SoftDevice
    0x00000000..0x00000FFF   (4KB) Master Boot Record
*/

/* Specify the memory areas (S132 2.0.1) */
MEMORY
{
    FLASH (rx)      : ORIGIN = 0x00000000, LENGTH = 0x080000 /* entire flash, 512 KiB */
    FLASH_ISR (rx)  : ORIGIN = 0x0001c000, LENGTH = 0x001000 /* sector 0, 4 KiB */
    FLASH_TEXT (rx) : ORIGIN = 0x0001d000, LENGTH = 0x038000 /* APP - ISR, 224 KiB */
    RAM (xrw)       : ORIGIN = 0x200039c0, LENGTH = 0x0c640  /* 49.5 KiB, give 8KiB headroom for softdevice */
}

/* produce a link error if there is not this amount of RAM for these sections */
_minimum_stack_size = 2K;
_minimum_heap_size = 16K;

/* top end of the stack */

/*_stack_end = ORIGIN(RAM) + LENGTH(RAM);*/
_estack = ORIGIN(RAM) + LENGTH(RAM);

/* RAM extents for the garbage collector */
_ram_end = ORIGIN(RAM) + LENGTH(RAM);
_heap_end = 0x20007000; /* tunable */

INCLUDE "boards/common.ld"