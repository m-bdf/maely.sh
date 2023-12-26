<script lang="ts">
	let history = '$ ';
	let command = 'help';
	let display = '';

	$: if (!display.startsWith(history)) display = history + command;

	const links = {
		GitHub: 'https://GitHub.com/m-bdf',
		LinkedIn: 'https://LinkedIn.com/in/bdf',
		Fiverr: 'https://Fiverr.com/maebdf'
	};

	const commands = {
		''() {
			return '';
		},
		about() {
			return 'about';
		},
		links() {
			return Object.entries(links)
				.map(([name, link]) => `<a contenteditable="false" href="${link}">${name}</a>`)
				.join('\n');
		},
		résumé() {
			setTimeout(open, 1000, 'resume');
			return 'Opening résumé…';
		},
		help() {
			return 'Type a command or press a button above.';
		},
		clear() {
			history = '$ ';
			return '';
		}
	};

	function execCommand() {
		command = command.trim().replace(/\s+/g, ' ');
		const cmd = command as keyof typeof commands;
		const out = (commands[cmd] ?? commands.help)();
		history += `${command}\n${out}\n\n$ `;
		display = history;
		command = '';
	}

	execCommand();
</script>

<svelte:head>
	<title>Maëlys' terminal</title>
</svelte:head>

<nav>
	{#each Object.keys(commands) as cmd}
		<button
			on:click={() => {
				command = cmd;
				execCommand();
			}}
		>
			{cmd}
		</button>
	{/each}
</nav>

<pre
	contenteditable="true"
	autocapitalize="off"
	spellcheck="false"
	bind:innerHTML={display}
	on:keyup={({ key, ctrlKey, shiftKey }) => {
		if (key == 'Enter' && !shiftKey) execCommand();
		else if (key == 'c' && ctrlKey) display = history;
		else command = display.slice(history.length);
	}}
/>

<style>
	:global(body) {
		height: 100vh;
		background: black;
		margin: 0;
		display: flex;
		flex-direction: column;
	}

	button {
		font-size: medium;
		margin: 1rem;
		padding: 0;
		background: none;
		color: #deafff;
		border: none;
		cursor: pointer;
	}

	pre {
		flex-grow: 1;
		padding: 1rem;
		background: none;
		color: white;
		border: none;
		outline: none;
		resize: none;
	}

	:global(a) {
		color: #deafff;
	}
</style>
