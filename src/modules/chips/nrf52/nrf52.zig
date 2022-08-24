pub const cpu = @import("cpu");
const micro = @import("microzig");
pub const registers = @import("registers.zig");
pub const VectorTable = registers.VectorTable;


pub fn parsePin(comptime spec: []const u8) type {
    // const invalid_format_msg = "The given pin '" ++ spec ++ "' has an invalid format. Pins must follow the format \"PIN{Pin}\" scheme.";

    // if (spec.len != 4 and spec.len != 5)
    //     @compileError(invalid_format_msg);
    // if (spec[0..2] != "PIN")
    //     @compileError(invalid_format_msg);

    return struct {
        pub const spec: [] const u8 = spec;
    };
}

pub const gpio = struct {
    pub fn setOutput(comptime pin: type) void {
        @field(registers.registers.P0.DIRSET.ref(), pin.spec) = 1;
    }

    pub fn setInput(comptime pin: type) void {
        @field(registers.registers.P0.DIRCLR.ref(), pin.spec) = 1;
    }

    pub fn read(comptime pin: type) micro.gpio.State {
        return @intToEnum(micro.gpio.State, @field(registers.registers.P0.IN.ref(), pin.spec));
    }

    pub fn write(comptime pin: type, state: micro.gpio.State) void {
        @field(registers.registers.P0.OUT.ref(), pin.spec) = @enumToInt(state);
    }

    pub fn toggle(comptime pin: type) void {
        @field(registers.registers.P0.OUT.ref(), pin.spec) = ~@field(registers.registers.P0.OUT.ref(), pin.spec);
    }
};