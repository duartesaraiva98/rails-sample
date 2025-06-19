# Rakefile

namespace :release do
  desc "Build Docker image, package Helm chart, and push to GHCR"
  task :deploy, [:app_version, :helm_version] do |_task, args|
    app_version = args[:app_version]
    helm_version = args[:helm_version]

    if app_version.nil? || helm_version.nil?
      raise ArgumentError, "Both app_version and helm_version must be provided"
    end

    registry_name = "ghcr.io/duartesaraiva98/rails-sample"
    helm_chart_dir = "helm"
    helm_chart_file = "#{helm_chart_dir}/Chart.yaml"

    # Step 1: Build Docker image
    sh "docker buildx build --platform linux/amd64 -t #{registry_name}:#{app_version} ."

    # Step 2: Push Docker image to GHCR
    sh "docker push #{registry_name}:#{app_version}"

    # Step 3: Update Helm/Chart.yaml with new versions
    new_content = []
    File.readlines(helm_chart_file).each do |line|
      if line.start_with?("version:")
        new_content << "version: #{helm_version}\n"
      elsif line.start_with?("appVersion:")
        new_content << "appVersion: #{app_version}\n"
      else
        new_content << line
      end
    end
    File.write(helm_chart_file, new_content.join)

    # Step 4: Package Helm chart
    sh "helm package #{helm_chart_dir}"

    # Step 5: Push Helm chart to GHCR
    chart_package = "rails-sample-#{helm_version}.tgz"
    sh "helm push #{chart_package} oci://#{registry_name}" # Replace with your Helm repository on GHCR

    # Step 6: Delete the packaged Helm chart file
    File.delete(chart_package) if File.exist?(chart_package)

    sh 'git add helm/Chart.yaml && git commit -m "Update helm versions" && git push origin HEAD'
  end
end