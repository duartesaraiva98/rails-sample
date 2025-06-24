namespace :app do
  desc "Build and run application"
  task :run do |_task, args|
    alloy_faro_endpoint = "https://alloy.alpha.boards.zorgdomein.nl/collect"
    alloy_faro_api_key = "dbd82ea1-ac36-49c0-a5a4-68206ee4b41b"
    sh "docker build -t rails-sample:latest ."

    sh "docker run -e RAILS_MASTER_KEY=5046713e1ac7263d8abe636a56ad715a -e APP_NAME=\"rails-sample\" -e FARO_ENDPOINT=\"#{alloy_faro_endpoint}\" -e FARO_API_KEY=\"#{alloy_faro_api_key}\" -e OTEL_SDK_DISABLED=\"true\" --rm -p 3000:3000 --network rails rails-sample:latest"
  end
end