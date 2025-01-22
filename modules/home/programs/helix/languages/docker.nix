{ pkgs, ... }:
with pkgs;
{
  language-server = {
    docker-langserver = {
      command = "${dockerfile-language-server-nodejs}/bin/docker-langserver";
      args = [ "--stdio" ];
    };
    docker-compose-langserver = {
      command = "${docker-compose-language-service}/bin/docker-compose-langserver";
      args = [ "--stdio" ];
    };
  };

  language = [
    {
      name = "dockerfile";
      scope = "source.dockerfile";
      injection-regex = "docker|dockerfile";
      roots = [ "Dockerfile" "Containerfile" ];
      file-types = [
        "Dockerfile"
        { glob = "Dockerfile"; }
        { glob = "Dockerfile.*"; }
        "dockerfile"
        { glob = "dockerfile"; }
        { glob = "dockerfile.*"; }
        "Containerfile"
        { glob = "Containerfile"; }
        { glob = "Containerfile.*"; }
        "containerfile"
        { glob = "containerfile"; }
        { glob = "containerfile.*"; }
      ];
      comment-token = "#";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      language-servers = [ "docker-langserver" ];
    }
    {
      name = "docker-compose";
      scope = "source.yaml.docker-compose";
      roots = [
        "docker-compose.yaml"
        "docker-compose.yml"
      ];
      language-servers = [
        "docker-compose-langserver"
        "yaml-language-server"
      ];
      file-types = [
        { glob = "docker-compose.yaml"; }
        { glob = "docker-compose.yml"; }
      ];
      comment-token = "#";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
    }
  ];
}
