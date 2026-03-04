import type { NextConfig } from 'next';
import bundleAnalyzer from '@next/bundle-analyzer';

const withBundleAnalyzer = bundleAnalyzer({
  enabled: process.env.ANALYZE === 'true',
});

const nextConfig: NextConfig = {
  output: 'standalone',
  typescript: { ignoreBuildErrors: false },
  images: {
    remotePatterns: [
      { protocol: 'https', hostname: '**.upwork.com' },
      { protocol: 'https', hostname: '**.freelancer.com' },
      { protocol: 'https', hostname: 'picsum.photos' },
    ],
  },
};

export default withBundleAnalyzer(nextConfig);
