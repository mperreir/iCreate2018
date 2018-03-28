using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class StarManager : MonoBehaviour {

	private List<StarScript> stars;
	private List<GalaxyScript> galaxies;

	public string criteria = "all";
	public float galaxyDensity = 200;
	public float galaxySpeed = 22;
	public int initialDisplayLimit = -1;
	public float minx = -10;
	public float maxx = 10;
	public float miny = -10;
	public float maxy = 10;
	public float minz = 0;
	public float maxz = 20;

	// Use this for initialization
	void Start ()
	{
		stars = new List<StarScript>();
		galaxies = new List<GalaxyScript>();
		StarScript prefab = (Resources.Load("Star/StarPrefab", typeof(GameObject)) as GameObject).GetComponent<StarScript>();
		StarScript star;
		StreamReader dataFile = new StreamReader("Assets/Resources/soldats_memorial_virtuel.csv");
		string rawLine = dataFile.ReadLine();
		string[] dataLine;
		string residence;
		string grade;
		string profession;
		string naissance;
		string volontaire;
		int age;
		int num ;
		int width = 0;
		bool firstLine = true;
		int i = 0;
		while (rawLine != null)
		{
			dataLine = rawLine.Split(';');
			if (firstLine)
			{
				width = dataLine.Length;
				firstLine = false;
			}
			else if (dataLine.Length == width)
			{
				residence = null;
				grade = null;
				profession = null;
				naissance = null;
				volontaire = null;
				age = 0;
				num = 0;
				width = 0;
				System.Int32.TryParse(dataLine[0], out num);
				System.Int32.TryParse(dataLine[11], out age);
				if (dataLine[13] != "")
				{
					residence = dataLine[13];
				}
				if (dataLine[15] != "")
				{
					grade = dataLine[15];
				}
				if (dataLine[6] != "")
				{
					volontaire = dataLine[6];
				}
				if (dataLine[3] != "")
				{
					profession = dataLine[3];
				}
				if (dataLine[1] != "")
				{
					naissance = dataLine[1];
				}
				star = Instantiate(prefab);
				star.transform.SetParent(this.transform);
				star.name = num.ToString();
				star.GetComponent<StarScript>().num = num;
				star.GetComponent<StarScript>().age = age;
				star.GetComponent<StarScript>().residence = residence;
				star.GetComponent<StarScript>().grade = grade;
				star.GetComponent<StarScript>().profession = profession;
				star.GetComponent<StarScript>().naissance = naissance;
				star.GetComponent<StarScript>().volontaire = volontaire;
				star.transform.position = new Vector3(this.minx - Random.value * (this.maxx-minx), this.miny - Random.value * (this.maxy - miny), this.minz - Random.value * (this.maxz - minz));
				if (i > this.initialDisplayLimit && this.initialDisplayLimit != -1)
				{
					star.gameObject.SetActive(false);
				}
				this.stars.Add(star);
				rawLine = dataFile.ReadLine();
				i++;
			}
		}
		dataFile.Close();
		this.ChangeCriteria(this.criteria);
	}

	void ChangeCriteria(string criteria)
	{
		int i;
		List<string> tags = new List<string>();
		this.criteria = criteria;
		for (i = 0; i < this.galaxies.Count; i++)
		{
			Destroy(this.galaxies[i]);
		}
		this.galaxies.Clear();
		if (criteria == "all")
		{
			this.galaxies.Add(CreateGalaxy(this.stars.Count, "all", "", this.galaxyDensity));
			for (i = 0; i < this.stars.Count; i++)
			{
				this.stars[i].MoveTo(this.galaxies[0]);
			}
		}
	}

	GalaxyScript FindGalaxy(string tag)
	{
		int i;
		for (i = 0; i < galaxies.Count; i++)
		{
			if (galaxies[i].tag == tag)
			{
				return galaxies[i];
			}
		}
		return null;
	}

	GalaxyScript CreateGalaxy(int num, string tag, string name, float density)
	{
		GalaxyScript galaxy = Instantiate((Resources.Load("Galaxy/GalaxyPrefab", typeof(GameObject)) as GameObject).GetComponent<GalaxyScript>());
		galaxy.name = tag;
		galaxy.galaxyTag = tag;
		galaxy.galaxyName = name;
		galaxy.radius = Mathf.Sqrt(num) / density;
		galaxy.transform.position = new Vector3(this.minx - Random.value * (this.maxx - minx), this.miny - Random.value * (this.maxy - miny), this.minz - Random.value * (this.maxz - minz));
		galaxy.rotator = new Vector3(1 - Random.value* 2, 1 - Random.value* 2, 1 - Random.value* 2);
		galaxy.name = tag;
		galaxy.transform.SetParent(this.transform);
		galaxy.speed = Random.value * this.galaxySpeed;
		this.galaxies.Add(galaxy);
		return galaxy;
	}
	// Update is called once per frame
	void Update ()
	{
		
	}
}
