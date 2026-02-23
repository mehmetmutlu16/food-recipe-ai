import { Sora, Bitter } from 'next/font/google';
import './globals.css';

const sora = Sora({
  subsets: ['latin'],
  variable: '--font-sora',
  display: 'swap'
});

const bitter = Bitter({
  subsets: ['latin'],
  variable: '--font-bitter',
  display: 'swap'
});

export const metadata = {
  title: 'AI Recipe Assistant Dashboard',
  description: 'Recipe generation analytics dashboard'
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={`${sora.variable} ${bitter.variable} antialiased`}>{children}</body>
    </html>
  );
}
