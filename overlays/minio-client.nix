self: super:
{
  minio-client = super.callPackage ./pkgs/minio-client { };
}
