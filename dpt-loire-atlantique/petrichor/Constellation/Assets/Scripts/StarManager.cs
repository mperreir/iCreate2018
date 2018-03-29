using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class StarManager : MonoBehaviour {

	private List<StarScript> stars;
	private List<GalaxyScript> galaxies;
	private List<string> residences;
	private List<string> professions;
	private List<string> volontaires;
	private List<string> grades;
	private List<string> naissances;
	private List<string> ages;
	private GameObject starsObject;
	private GameObject galaxiesObject;

	public string criteria = "all";
	public float galaxyDensity = 200;
	public float galaxyMinSpeed = 10;
	public float galaxyMaxSpeed = 25;
	public int initialDisplayLimit = -1;
	public float joinspeed = 2;
	public float minx = -10;
	public float maxx = 10;
	public float miny = -10;
	public float maxy = 10;
	public float minz = 0;
	public float maxz = 20;

	// Use this for initialization
	void Start ()
	{
		this.residences = new List<string>();
		this.professions = new List<string>();
		this.volontaires = new List<string>();
		this.grades = new List<string>();
		this.ages = new List<string>();
		this.naissances = new List<string>();
		stars = new List<StarScript>();
		galaxies = new List<GalaxyScript>();
		StarScript prefab = (Resources.Load("Star/StarPrefab", typeof(GameObject)) as GameObject).GetComponent<StarScript>();
		this.starsObject = new GameObject();
		this.starsObject.name = "stars";
		this.starsObject.transform.SetParent(this.transform);
		this.galaxiesObject = new GameObject();
		this.galaxiesObject.name = "galaxies";
		this.galaxiesObject.transform.SetParent(this.transform);
		StarScript star;
		StreamReader dataFile = new StreamReader("Assets/Data/Soldats.csv");
		string rawLine = dataFile.ReadLine();
		string[] dataLine;
		string residence;
		string grade;
		string profession;
		string naissance;
		string volontaire;
		int age;
		int num;
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
				age = 0;
				num = 0;
				System.Int32.TryParse(dataLine[0], out num);
				System.Int32.TryParse(dataLine[11], out age);
				if (age != 0 && !this.ages.Contains(age.ToString()))
				{
					this.ages.Add(age.ToString());
				}
				residence = dataLine[13].ToLower();
				if (residence != "" && !this.residences.Contains(residence))
				{
					this.residences.Add(residence);
				}
				grade = dataLine[15].ToLower();
				if (grade != "" && !this.grades.Contains(grade))
				{
					this.grades.Add(grade);
				}
				volontaire = dataLine[6].ToLower();
				if (volontaire != "" && !this.volontaires.Contains(volontaire))
				{
					this.volontaires.Add(volontaire);
				}
				profession = dataLine[3].ToLower();
				if (profession != "" && !this.professions.Contains(profession))
				{
					this.professions.Add(profession);
				}
				naissance = dataLine[1].ToLower();
				if (naissance != "" && naissance.Split('/').Length == 3 && !this.naissances.Contains(naissance.Split('/')[2]))
				{
					this.naissances.Add(naissance.Split('/')[2]);
				}
				star = Instantiate(prefab);
				star.transform.SetParent(this.starsObject.transform);
				star.name = i.ToString();
				star.num = num;
				star.age = age;
				star.residence = residence;
				star.grade = grade;
				star.profession = profession;
				star.naissance = naissance;
				star.volontaire = volontaire;
				star.joinSpeed = this.joinspeed;
				star.transform.position = new Vector3(this.minx + Random.value * (this.maxx - minx), this.miny + Random.value * (this.maxy - miny), this.minz + Random.value * (this.maxz - minz));
				if (i > this.initialDisplayLimit && this.initialDisplayLimit != -1)
				{
					star.gameObject.SetActive(false);
				}
				this.stars.Add(star);
				i++;
			}
			rawLine = dataFile.ReadLine();
		}
		dataFile.Close();
		this.ChangeCriteria(this.criteria);
	}

	void ChangeCriteria(string criteria)
	{
		int i, num;
		this.criteria = criteria;
		GalaxyScript galaxy;
		for (i = 0; i < this.stars.Count; i++)
		{
			this.stars[i].FreeStar(this.starsObject);
		}
		for (i = 0; i < this.galaxies.Count; i++)
		{
			Destroy(this.galaxies[i].gameObject);
		}
		this.galaxies.Clear();
		if (criteria == "all")
		{
			this.galaxies.Add(CreateGalaxy(this.stars.Count, "ils sont morts", this.galaxyDensity));
			for (i = 0; i < this.stars.Count; i++)
			{
				this.stars[i].MoveTo(this.galaxies[0]);
			}
		}
		else if (criteria == "none")
		{
			for (i = 0; i < this.stars.Count; i++)
			{
				this.stars[i].FreeStar(this.starsObject.gameObject);
			}
		}
		else if (criteria == "residence")
		{
			
			num = this.stars.Count / this.residences.Count;
			this.galaxies.Add(CreateGalaxy(num, "ils y habitaient", this.galaxyDensity));
			for (i = 0; i < this.residences.Count; i++)
			{
				this.galaxies.Add(this.CreateGalaxy(num, this.residences[i], this.galaxyDensity));
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].residence);
				if (galaxy == null)
				{
					stars[i].MoveTo(this.galaxies[0]);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		else if (criteria == "profession")
		{

			num = this.stars.Count / this.professions.Count;
			this.galaxies.Add(CreateGalaxy(num, "ils etaient", this.galaxyDensity));
			for (i = 0; i < this.professions.Count; i++)
			{
				this.galaxies.Add(this.CreateGalaxy(num, this.professions[i], this.galaxyDensity));
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].profession);
				if (galaxy == null)
				{
					stars[i].MoveTo(this.galaxies[0]);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		else if (criteria == "grade")
		{

			num = this.stars.Count / this.grades.Count;
			this.galaxies.Add(CreateGalaxy(num, "ils etaient", this.galaxyDensity));
			for (i = 0; i < this.grades.Count; i++)
			{
				this.galaxies.Add(this.CreateGalaxy(num, this.grades[i], this.galaxyDensity));
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].grade);
				if (galaxy == null)
				{
					stars[i].MoveTo(this.galaxies[0]);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		else if (criteria == "naissance")
		{

			num = this.stars.Count / this.naissances.Count;
			this.galaxies.Add(CreateGalaxy(num, "ils sont nées en", this.galaxyDensity));
			for (i = 0; i < this.naissances.Count; i++)
			{
				this.galaxies.Add(this.CreateGalaxy(num, this.naissances[i], this.galaxyDensity));
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].naissance);
				if (galaxy == null)
				{
					stars[i].MoveTo(this.galaxies[0]);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		else if (criteria == "volontaire")
		{

			num = this.stars.Count / this.volontaires.Count;
			this.galaxies.Add(CreateGalaxy(num, "ils étaient volontaire", this.galaxyDensity));
			for (i = 0; i < this.volontaires.Count; i++)
			{
				this.galaxies.Add(this.CreateGalaxy(num, this.volontaires[i], this.galaxyDensity));
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].volontaire);
				if (galaxy == null)
				{
					stars[i].MoveTo(this.galaxies[0]);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		else if (criteria == "age")
		{

			num = 0;
			
			this.galaxies.Add(CreateGalaxy(num, "ils avais", this.galaxyDensity));
			for (i = 0; i < this.ages.Count; i++)
			{
				this.galaxies.Add(this.CreateGalaxy(num, this.ages[i], this.galaxyDensity));
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].age.ToString());
				if (galaxy == null)
				{
					stars[i].MoveTo(this.galaxies[0]);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
	}
	
	// Update is called once per frame
	void Update ()
	{
		
	}

	private GalaxyScript FindGalaxy(string tag)
	{
		int i;
		for (i = 0; i < galaxies.Count; i++)
		{
			if (galaxies[i].galaxyTag == tag)
			{
				return galaxies[i];
			}
		}
		return null;
	}

	private GalaxyScript CreateGalaxy(int num, string tag, float density)
	{
		GalaxyScript galaxy = Instantiate((Resources.Load("Galaxy/GalaxyPrefab", typeof(GameObject)) as GameObject).GetComponent<GalaxyScript>());
		galaxy.name = tag;
		galaxy.galaxyTag = tag;
		galaxy.radius = Mathf.Pow(num / density, 1/3F);
		galaxy.transform.position = new Vector3(this.minx + Random.value * (this.maxx - minx), this.miny + Random.value * (this.maxy - miny), this.minz + Random.value * (this.maxz - minz));
		galaxy.rotator = new Vector3(1 - Random.value * 2, 1 - Random.value * 2, 1 - Random.value * 2);
		galaxy.name = tag;
		galaxy.transform.SetParent(this.galaxiesObject.transform);
		galaxy.speed = this.galaxyMinSpeed + Random.value * (this.galaxyMaxSpeed - this.galaxyMinSpeed);
		this.galaxies.Add(galaxy);
		return galaxy;
	}

	public void NextCriteria()
	{
		string criteria = "all";
		if (this.criteria == "age")
		{
			criteria = "grade";
		}
		else if (this.criteria == "grade")
		{
			criteria = "profession";
		}
		else if (this.criteria == "naissance")
		{
			criteria = "volontaire";
		}
		else if (this.criteria == "profession")
		{
			criteria = "residence";
		}
		else if (this.criteria == "residence")
		{
			criteria = "naissance";
		}
		else if (this.criteria == "volontaire")
		{
			criteria = "age";
		}
		this.ChangeCriteria(criteria);
	}

	public void Scint()
	{
	}

	public void ResetStars()
	{
	}

	public void SpawnStars(int num)
	{
	}
}
