docker_service 'default' do
  action [:create, :start]
end

# Pull docker image
docker_image node[:rabbitmq][:docker_image] do
	tag node[:rabbitmq][:docker_image_tag]
	action :pull
	notifies :redeploy, "docker_container[rabbitmq]", :immediately
end

# Cread volumens directory
directory node[:rabbitmq][:log_path] do
	recursive true
	action :create
end
directory node[:rabbitmq][:data_path] do
	recursive true
	action :create
end

# Run the docker container
docker_container "rabbitmq" do
	image node[:rabbitmq][:docker_image]
	tag node[:rabbitmq][:docker_image_tag]
	container_name node[:rabbitmq][:docker_container]
	detach true
	port ['5672:5672', '15672:15672']
	volumes ["#{node[:rabbitmq][:data_path]}:/var/lib/rabbitmq"]
	restart_policy 'always'
end
