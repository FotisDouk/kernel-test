#![no_std]
#![no_main]

use core::panic::PanicInfo;

#[no_mangle]
pub extern "C" fn _start() -> ! {
    let vga = 0xb8000 as *mut u8;
    unsafe {
        *vga = b'H';
        *vga.add(1) = 0x0F;
        *vga.add(2) = b'i';
        *vga.add(3) = 0x0F;
    }

    loop {}
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
