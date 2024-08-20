use clap::Args as ClapArgs;

#[derive(ClapArgs, PartialEq)]
pub(crate) struct Args {
    
}

pub(crate) async fn run(args: Args) -> eyre::Result<()> {
    todo!();
}
