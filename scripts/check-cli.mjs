import { execSync } from 'node:child_process';

const [command, ...args] = process.argv.slice(2);

if (!command) {
  console.error('Usage: node scripts/check-cli.mjs <command> [args...]');
  process.exit(1);
}

try {
  execSync(`command -v ${command}`, { stdio: 'ignore' });
} catch {
  console.error(`${command} not found.`);
  console.error(`Install with: brew install ${command}`);
  process.exit(1);
}

execSync([command, ...args].join(' '), { stdio: 'inherit' });
