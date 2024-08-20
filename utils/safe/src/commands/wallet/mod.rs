use clap::{Args as ClapArgs, ValueEnum};
use clap::{CommandFactory, Subcommand};

pub(crate) mod balance;
pub(crate) mod owners;
pub(crate) mod threshold;

#[derive(Subcommand, PartialEq)]
pub(crate) enum Command {
    #[clap(about = "Get the balance of a wallet.")]
    Balance(balance::Args),
    #[clap(about = "Get the owners of a wallet.")]
    Owners(owners::Args),
    #[clap(about = "Get the threshold of a wallet.")]
    Threshold(threshold::Args),
}

pub(crate) async fn start(cmd: Command) -> eyre::Result<()> {
    match cmd {
        Command::Balance(args) => balance::run(args).await?,
        Command::Owners(args) => owners::run(args).await?,
        Command::Threshold(args) => threshold::run(args).await?,
    };

    Ok(())
}
