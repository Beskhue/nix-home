{ stdenv, buildGo113Module, fetchFromGitHub }:

buildGo113Module rec {
  name = "minio-client-${version}";
  version = "2019-10-09T22-54-57Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "0n32snmlg6qims2xkyk4ah1a2anawl7dxrvmhc52mni964lwvrq4";
  };

  preBuild = ''
    export GOSUMDB="off"
  '';

  modSha256 = "0cr6hiq4x7iyhy96l7n9avzzs318hydyali2kbvkgz5k326y1d1k";
  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = https://github.com/minio/mc;
    description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
