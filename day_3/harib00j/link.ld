OUTPUT_FORMAT("binary")
ENTRY(HariMain)

SECTIONS
{
    . = 0x8200;          /* 内核加载地址 */
    
    .text : {
        *(.text)
    }
    
    .data : {
        *(.data)
    }
    
    .bss : {
        *(.bss)
    }
    
    /DISCARD/ : {
        *(.note*)
        *(.comment*)
    }
}