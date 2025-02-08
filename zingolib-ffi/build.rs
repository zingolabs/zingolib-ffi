fn main() {
    uniffi_build::generate_scaffolding("src/zingolib.udl").expect("A valid UDL file");
}
