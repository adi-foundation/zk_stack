use clap::{Args as ClapArgs, ValueEnum};
use clap::{CommandFactory, Subcommand};

pub(crate) mod propose;
pub(crate) mod sign;
pub(crate) mod execute;

#[derive(Subcommand, PartialEq)]
pub(crate) enum Command {
    #[clap(about = "Generate autocomplete shell script.")]
    Propose(propose::Args),
    #[clap(about = "Generate and install autocomplete shell script.")]
    Sign(sign::Args),
    #[clap(about = "Execute")]
    Execute(execute::Args),
}

pub(crate) async fn start(cmd: Command) -> eyre::Result<()> {
    match cmd {
        Command::Propose(args) => propose::run(args).await?,
        Command::Sign(args) => sign::run(args).await?,
        Command::Execute(args) => execute::run(args).await?,
    };

    Ok(())
}
