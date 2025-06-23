namespace :app do
  desc "Build and run application"
  task :run do |_task, args|
    sentry_dsn = "https://9e050e6871d08d541e5e155032f0e96e@o195517.ingest.us.sentry.io/4509429137997824"
    otlp_endpoint = "https://alloy.internal.alpha.boards.zorgdomein.nl:4318"
    sh "docker build -t rails-sample:latest ."

    sh "trap 'kill -SIGKILL 0' EXIT; docker run -e RAILS_MASTER_KEY=5046713e1ac7263d8abe636a56ad715a -e SENTRY_DSN=\"#{sentry_dsn}\" -e OTEL_EXPORTER_OTLP_ENDPOINT=\"#{otlp_endpoint}\" -e OTEL_LOG_LEVEL=\"debug\" --rm -p 3000:3000 --network rails rails-sample:latest"
  end
end