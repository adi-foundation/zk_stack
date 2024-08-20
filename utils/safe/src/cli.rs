use crate::commands::{transaction, wallet};
use clap::{Parser, Subcommand};

pub const VERSION_STRING: &str = env!("CARGO_PKG_VERSION");

#[derive(Parser)]
#[command(name="safe", author, version=VERSION_STRING, about, long_about = None)]
pub struct SafeCLI {
    #[command(subcommand)]
    command: SafeCommand,
}

#[derive(Subcommand, PartialEq)]
enum SafeCommand {
    #[clap(subcommand, about = "Transaction interaction commands.")]
    Transaction(transaction::Command),
    #[clap(subcommand, about = "Wallet interaction commands.")]
    Wallet(wallet::Command),
}

pub async fn start() -> eyre::Result<()> {
    let SafeCLI { command } = SafeCLI::parse();
    match command {
        SafeCommand::Transaction(cmd) => transaction::start(cmd).await?,
        SafeCommand::Wallet(cmd) => wallet::start(cmd).await?,
    };

    Ok(())
}
