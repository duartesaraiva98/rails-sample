# Rakefile
require 'yaml'


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
    helm_chart_package = "rails-sample-#{helm_version}.tgz"

    # Load the YAML file into a Ruby object
    helm_chart = YAML.load_file(helm_chart_file)

    is_release_docker = helm_chart["appVersion"] != app_version
    is_release_helm = helm_chart["version"] != helm_version

    if is_release_docker
      sh "docker buildx build --platform linux/amd64 -t #{registry_name}:#{app_version} ."
      sh "docker push #{registry_name}:#{app_version}"

      helm_chart["appVersion"] = app_version
    end

    if is_release_helm
      sh "helm package #{helm_chart_dir} --app-version #{app_version} --version #{helm_version}"
      sh "helm push #{helm_chart_package} oci://#{registry_name}" # Replace with your Helm repository on GHCR

      File.delete(helm_chart_package) if File.exist?(helm_chart_package)

      helm_chart["version"] = helm_version
    end

    if is_release_docker || is_release_helm
      File.write(helm_chart_file, helm_chart.to_yaml)

      sh 'git add helm/Chart.yaml && git commit -m "Update helm chart version(s)" && git push origin HEAD'
    end
  end
end