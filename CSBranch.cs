using Godot;
using System;

public partial class CSBranch : Node
{
	private CSBranch left;
	private CSBranch right;
	private Vector2I position;
	private Vector2I size;

	public CSBranch(Vector2I position_, Vector2I size_)
	{
		position = position_;
		size = size_;
		GD.Print(position);
	}
}
