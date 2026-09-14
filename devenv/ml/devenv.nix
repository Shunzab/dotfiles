{ pkgs, ... }:

{
  languages.python = {
    enable = true;
    venv.enable = true;
    uv = {
      enable = true;
    };
    package = pkgs.python3.withPackages (ps: [
      ps.numpy
      ps.pandas
      ps.matplotlib
      ps.scipy
      ps.scikit-learn
      ps.torch
      #ps.tensorflow # currently broken in nixpkgs
      ps.fastai
      ps.fastapi
      ps.uvicorn
      ps.fastapi-cli
      ps.jupyter
      ps.seaborn
    ]);
  };
}
