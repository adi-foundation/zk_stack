use crate::commands::utils::balance::get_l1_balance;
use clap::Parser;
use zksync_ethers_rs::{providers::Provider, types::Address};

#[derive(Parser, PartialEq)]
pub(crate) struct Args {
    #[clap(required = true, help = "The address of the Safe wallet.")]
    pub wallet_address: Address,
    #[clap(help = "The address of the token to check the balance of.")]
    pub token_address: Option<Address>,
    #[arg(short = 'r', long = "rpc-url", help = "The RPC URL of the L1 network.", default_value = "https://rpc.sepolia.org")]
    pub l1_rpc_url: String,
}

pub(crate) async fn run(args: Args) -> eyre::Result<()> {
    let l1_provider = Provider::try_from(args.l1_rpc_url)?;

    let (balance, symbol) = get_l1_balance(args.token_address, &l1_provider, args.wallet_address).await?;
    println!("Balance: {balance} {symbol}");

    Ok(())
}
