use clap::Args as ClapArgs;
use zksync_ethers_rs::types::H256;

#[derive(ClapArgs, PartialEq)]
pub(crate) struct Args {
    #[clap(help = "The address of the Safe wallet.")]
    safe_address: String,
    #[clap(help = "The hash of the Safe transaction.")]
    safe_tx_hash: H256,
}

pub(crate) async fn run(args: Args) -> eyre::Result<()> {
    todo!()
}
