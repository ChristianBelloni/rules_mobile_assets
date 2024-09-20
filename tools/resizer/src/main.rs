use std::path::PathBuf;

use clap::Parser;

fn main() {
    let args = Args::parse();
    let input = std::fs::canonicalize(&args.svg).unwrap().to_path_buf();
    let mut opt = resvg::usvg::Options::default();
    opt.resources_dir = input.parent().map(|a| a.to_path_buf());
    opt.fontdb_mut().load_system_fonts();
    let svg_data = std::fs::read(&input).unwrap();
    let svg = resvg::usvg::Tree::from_data(&svg_data, &opt).unwrap();

    let mut pixmap = resvg::tiny_skia::Pixmap::new(args.size, args.size).unwrap();
    resvg::render(
        &svg,
        resvg::tiny_skia::Transform::default(),
        &mut pixmap.as_mut(),
    );
    pixmap.save_png(&args.out).unwrap();
}

#[derive(Debug, clap::Parser)]
struct Args {
    #[clap(long)]
    /// Input svg
    pub svg: PathBuf,
    #[clap(long)]
    /// Output path
    pub out: PathBuf,
    #[clap(long)]
    /// Output size in pixels
    pub size: u32,
}
