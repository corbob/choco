using System.Text.RegularExpressions;

private var titlePattern = @"^(?=.{0,50}$)(?:\(.*\)).*$";
private var commitFile = Args[0];
private var commitMessage = File.ReadAllLines(commitFile);
private var title = commitMessage[0];
private var exitCode = 0;
private var startLine = 2;
private var commitStringBuilder = new StringBuilder();
private var issuesStringBuilder = new StringBuilder();
private var lineStringBuilder = new StringBuilder();

if (!Regex.IsMatch(title, titlePattern)) {
	issuesStringBuilder.AppendLine(@"Your title doesn't match the required format for the title");
	exitCode++;
}

commitStringBuilder.AppendLine(title);
commitStringBuilder.AppendLine();

// Determine if there is a blank line. We've already added it so we have no need to add it from the array.
if (!string.IsNullOrWhiteSpace(commitMessage[1])) {
	startLine = 1;
}

for (int i = startLine ; i < commitMessage.Length ; i++) {
	lineStringBuilder.Clear();
	lineStringBuilder.Append(commitMessage[i]);
	var lineDone = false;

	while (!lineDone) {
		if (lineStringBuilder.Length > 72) {
			string str = lineStringBuilder.ToString();
			int len = str.Substring(0,72).LastIndexOf(' ');
			commitStringBuilder.AppendLine(str.Substring(0,len));
			lineStringBuilder.Remove(0, len+1);
		} else {
			commitStringBuilder.AppendLine(lineStringBuilder.ToString());
			lineDone = true;
		}
	}
}

File.WriteAllText(commitFile, commitStringBuilder.ToString());
Console.Write(issuesStringBuilder.ToString());
return exitCode;
