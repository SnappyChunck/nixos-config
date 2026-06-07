{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "toofan";
  version = "master";

  src = fetchFromGitHub {
    owner = "vyrx-dev";
    repo = "toofan";
    rev = "master";
    hash = "sha256-i615Ok6wY6oNYtYtwqrFsy9WnR06SceIcGsTxA+t9b8=";   
  };

  vendorHash = "sha256-YSjJ8NOL97hXZLnfGYIjoKmARv+gWOsv+5qkl9konnA=";

  meta = with lib; {
    description = "A tool built from source";
    homepage = "https://github.com/vyrx-dev/toofan";
    license = licenses.mit;
    mainProgram = "toofan";
  };
}
