use std::{
    fs::File,
    io::{BufWriter, Read, Write},
    path::PathBuf,
};

use clap::Parser;
use webp::{Encoder, PixelLayout};

fn main() {
    let args = Args::parse();
    let input = std::fs::canonicalize(&args.svg).unwrap().to_path_buf();
    let mut opt = resvg::usvg::Options::default();
    opt.resources_dir = input.parent().map(|a| a.to_path_buf());
    opt.fontdb_mut().load_system_fonts();
    let svg_data = std::fs::read(&input).unwrap();
    let svg = resvg::usvg::Tree::from_data(&svg_data, &opt).unwrap();

    let mut pixmap = resvg::tiny_skia::Pixmap::new(args.size, args.size).unwrap();
    let current_size = svg.size();

    let transform_x = args.size as f32 / current_size.width();
    let transform_y = args.size as f32 / current_size.height();
    resvg::render(
        &svg,
        resvg::tiny_skia::Transform::from_scale(transform_x, transform_y),
        &mut pixmap.as_mut(),
    );

    if args.webp {
        let encoder = Encoder::new(
            pixmap.data(),
            PixelLayout::Rgba,
            pixmap.width(),
            pixmap.height(),
        );
        let image = encoder.encode(100.0);
        let out = File::create(&args.out).unwrap();
        let mut out = BufWriter::new(out);
        out.write_all(&image).unwrap();
        out.flush().unwrap();
    } else {
        pixmap.save_png(&args.out).unwrap();
    }
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

    #[clap(long, default_value = "false")]
    pub webp: bool,
}
