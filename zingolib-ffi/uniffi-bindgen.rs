// use camino::Utf8Path;
// use uniffi::KotlinBindingGenerator;

fn main() {
    uniffi::uniffi_bindgen_main()

    // uniffi::generate_bindings(
    //     Utf8Path::new("src/zingolib.udl"),
    //     None,
    //     KotlinBindingGenerator,
    //     Some(Utf8Path::new("../zingolib-kotlin")),
    //     None,
    //     Some("zingolib"),
    //     true,
    // )
    // .unwrap();
}
