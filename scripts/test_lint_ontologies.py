#!/usr/bin/env python3

import unittest

from scripts.lint_ontologies import check_applicability, is_l5_archetype_id


ARCHETYPE_ID = "gsmarc://gsm-ontology/test/domain/Root/v1"


class ApplicabilityLintTest(unittest.TestCase):
    def lint(self, expression, archetype_ids=None):
        errors = []
        check_applicability(
            "test",
            "Example.norm.json",
            {"applicability": expression},
            {ARCHETYPE_ID} if archetype_ids is None else archetype_ids,
            errors,
        )
        return errors

    def test_accepts_exact_catalogue_archetype_reference(self):
        self.assertEqual([], self.lint(f'ref("{ARCHETYPE_ID}").enabled == true'))

    def test_rejects_bare_title_root(self):
        self.assertIn("bare applicability root", self.lint("Root.enabled == true")[0])

    def test_rejects_malformed_ref_call(self):
        self.assertIn("malformed ref() call", self.lint("ref(Root).enabled == true")[0])

    def test_rejects_unknown_archetype(self):
        errors = self.lint(
            'ref("gsmarc://gsm-ontology/test/domain/Missing/v1").enabled == true'
        )
        self.assertIn("not a governed L5-coherent catalogue Archetype", errors[0])

    def test_rejects_registered_non_archetype_identity(self):
        errors = self.lint(f'ref("{ARCHETYPE_ID}").enabled == true', set())
        self.assertIn("not a governed L5-coherent catalogue Archetype", errors[0])

    def test_rejects_invalid_identity_grammar(self):
        errors = self.lint(
            'ref("gsmarc://gsm-ontology/test/domain/Root/v0").enabled == true'
        )
        self.assertIn("does not match the Archetype URI grammar", errors[0])


class L5IdentityTest(unittest.TestCase):
    def test_accepts_identity_derived_from_package_path(self):
        self.assertTrue(
            is_l5_archetype_id(
                "test", "domain/Root.archetype.json", "Root", ARCHETYPE_ID
            )
        )

    def test_rejects_identity_not_derived_from_package_path(self):
        self.assertFalse(
            is_l5_archetype_id(
                "test",
                "domain/Root.archetype.json",
                "Root",
                "gsmarc://gsm-ontology/test/other/Root/v1",
            )
        )


if __name__ == "__main__":
    unittest.main()