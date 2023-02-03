import argparse
import re

from bs4 import BeautifulSoup


def extract_variables(html_string):
    soup = BeautifulSoup(html_string, 'html.parser')
    result = {}
    for p in soup.find_all('p'):
        strong_tags = p.find_all('strong')
        for i in range(0, len(strong_tags), 2):
            key = strong_tags[i].text.rstrip(':')
            value = strong_tags[i + 1].text
            result[key] = value
    result['Hostname'] = soup.find('a').text
    result['PgAdminUrl'] = soup.find_all('a')[1].text
    return result


def pascal_to_all_caps(input: str) -> str:
    words = [word.upper() for word in re.findall(r'[A-Z][a-z]*', input)]
    return "_".join(words)


def main(success_text_file: str):
    with open(success_text_file, "r") as file:
        html_string = file.read()
        variables = extract_variables(html_string)
        for key, value in variables.items():
            print(
                f"##teamcity[setParameter name='env.{pascal_to_all_caps(key)}' value='{value}']"
            )


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--success-text-file",
        action="store",
        required=True,
    )
    args = parser.parse_args()
    main(args.success_text_file)
