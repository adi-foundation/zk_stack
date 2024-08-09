export const bold = (text: string) => `*${text}*`;
export const italic = (text: string) => `_${text}_`;

// Box styling for the console output
export const box = (lines: string[]) => {
    const maxWidth = lines.reduce((max, line) => Math.max(max, line.length), 0);;
    const line = "-".repeat(maxWidth + 4);
    const formattedLines = lines.map(line => `${line.padEnd(maxWidth)}`);
    return `\n${line}\n${formattedLines.join('\n')}\n${line}\n`;
};

export const flushMessageStack  = (messageStack: string[]) => {
    console.log(box(messageStack));
    return [];
};
