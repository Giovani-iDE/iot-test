use rmqtt::{context::ServerContext, net::Builder, server::MqttServer, Result};
use simple_logger::SimpleLogger;

#[tokio::main]
async fn main() -> Result<()> {
  SimpleLogger::new()
        .with_level(log::LevelFilter::Info)
        .init()?;

    let scx = ServerContext::new().plugins_dir("plugins/").build().await;


    MqttServer::new(scx)
        .listener(
            Builder::new()
                .name("external/tls")
                .laddr(([0, 0, 0, 0], 8883).into())
                .tls_key(Some("/etc/ssl/private/server.key"))
                .tls_cert(Some("/etc/ssl/certs/server.crt"))
                .tls_cross_certificate(false)
                .bind()?
                .tls()?,
        )
        .build()
        .run()
        .await?;

    Ok(())
}